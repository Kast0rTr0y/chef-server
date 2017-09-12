require 'pedant/rspec/common'

describe "/_stats API endpoint", :stats do

  response_type_map = {
    "erlang_vm_time_correction" => "UNTYPED",
    "erlang_vm_thread_pool_size" => "GAUGE",
    "erlang_vm_threads" => "UNTYPED",
    "erlang_vm_smp_support" => "UNTYPED",
    "erlang_vm_schedulers_online" => "GAUGE",
    "erlang_vm_schedulers" => "GAUGE",
    "erlang_vm_process_limit" => "GAUGE",
    "erlang_vm_process_count" => "GAUGE",
    "erlang_vm_port_limit" => "GAUGE",
    "erlang_vm_port_count" => "GAUGE",
    "erlang_vm_logical_processors_online" => "GAUGE",
    "erlang_vm_logical_processors_available" => "GAUGE",
    "erlang_vm_logical_processors" => "GAUGE",
    "erlang_vm_ets_limit" => "GAUGE",
    "erlang_vm_statistics_wallclock_time_milliseconds" => "COUNTER",
    "erlang_vm_statistics_runtime_milliseconds" => "COUNTER",
    "erlang_vm_statistics_run_queues_length_total" => "GAUGE",
    "erlang_vm_statistics_reductions_total" => "COUNTER",
    "erlang_vm_statistics_bytes_output_total" => "COUNTER",
    "erlang_vm_statistics_bytes_received_total" => "COUNTER",
    "erlang_vm_statistics_garbage_collection_bytes_reclaimed" => "COUNTER",
    "erlang_vm_statistics_garbage_collection_words_reclaimed" => "COUNTER",
    "erlang_vm_statistics_garbage_collection_number_of_gcs" => "COUNTER",
    "erlang_vm_statistics_context_switches" => "COUNTER",
    "erlang_vm_memory_system_bytes_total" => "GAUGE",
    "erlang_vm_memory_processes_bytes_total" => "GAUGE",
    "erlang_vm_ets_tables" => "GAUGE",
    "erlang_vm_dets_tables" => "GAUGE",
    "erlang_vm_memory_bytes_total" => "GAUGE",
    "erlang_vm_memory_atom_bytes_total" => "GAUGE",
    "erchef_pooler_queued_requestors_max" => "GAUGE",
    "erchef_pooler_queued_requestors" => "GAUGE",
    "erchef_pooler_members_max" => "GAUGE",
    "erchef_pooler_members_free" => "GAUGE",
    "erchef_pooler_members_in_use" => "GAUGE",
    "pg_stat_n_conns" => "GAUGE",
    "pg_stat_n_active_conns" => "GAUGE",
    "pg_stat_tidx_blks_hit" => "COUNTER",
    "pg_stat_tidx_blks_read" => "COUNTER",
    "pg_stat_toast_blks_hit" => "COUNTER",
    "pg_stat_toast_blks_read" => "COUNTER",
    "pg_stat_idx_blks_hit" => "COUNTER",
    "pg_stat_idx_blks_read" => "COUNTER",
    "pg_stat_heap_blocks_hit" => "COUNTER",
    "pg_stat_heap_blocks_read" => "COUNTER",
    "pg_stat_n_dead_tup" => "GAUGE",
    "pg_stat_n_live_tup" => "GAUGE",
    "pg_stat_n_tup_del" => "COUNTER",
    "pg_stat_n_tup_upd" => "COUNTER",
    "pg_stat_n_tup_ins" => "COUNTER",
    "pg_stat_tup_fetch" => "COUNTER",
    "pg_stat_idx_scan" => "COUNTER",
    "pg_stat_seq_tup_read" => "COUNTER",
    "pg_stat_seq_scan" => "COUNTER"
  }

  let(:request_url) { "#{platform.server}/_stats" }
  let(:response_body) do
    response_type_map.map do |name, type|
      {
        "name" => name,
        "type" => type
      }
    end
  end

  let(:boolean_stats) { ["erlang_vm_time_correction", "erlang_vm_threads", "erlang_vm_smp_support"] }

  # Figure out how to setup enable/disable basic-auth for test without chef-server-ctl reconfigure.
  it "returns a list of collected statistics", :smoke do
    get(request_url, platform.non_admin_user).should look_like({
      :status => 200,
      :body => response_body
    })
  end

  response_type_map.each do |name, type|
    it "returns metrics for #{name} typed as #{type}", :smoke do
      response = JSON.parse(get(request_url, platform.non_admin_user))
      stat = response.find { |s| s["name"] == name }
      expect(stat["metrics"]).not_to be_empty
      stat["metrics"].each do |metric|
        expect(metric).to have_key("value")
        case type
        when "GAUGE"
          expect(Float(metric["value"])).to be_a(Numeric)
        when "COUNTER"
          expect(Integer(metric["value"])).to be_a(Integer)
        when "UNTYPED"
          expect(boolean_stats).to include(name)
          expect(metric["value"]).to eq("1").or eq("0")
        else
          raise "Unimplemented test for metric type #{type}"
        end
      end
    end
  end
end
