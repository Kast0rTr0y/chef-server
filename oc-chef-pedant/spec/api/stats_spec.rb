require 'pedant/rspec/common'

describe "/_stats API endpoint", :stats do

  let(:request_url) { "#{platform.server}/_stats" }
  let(:response_body) do
    [
      {
        "name" => "erlang_vm_time_correction",
        "type" => "UNTYPED",
      },
      {
        "name" => "erlang_vm_thread_pool_size",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_threads",
        "type" => "UNTYPED",
      },
      {
        "name" => "erlang_vm_smp_support",
        "type" => "UNTYPED",
      },
      {
        "name" => "erlang_vm_schedulers_online",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_schedulers",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_process_limit",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_process_count",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_port_limit",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_port_count",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_logical_processors_online",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_logical_processors_available",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_logical_processors",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_ets_limit",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_statistics_wallclock_time_milliseconds",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_runtime_milliseconds",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_run_queues_length_total",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_statistics_reductions_total",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_bytes_output_total",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_bytes_received_total",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_garbage_collection_bytes_reclaimed",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_garbage_collection_words_reclaimed",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_garbage_collection_number_of_gcs",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_statistics_context_switches",
        "type" => "COUNTER",
      },
      {
        "name" => "erlang_vm_memory_system_bytes_total",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_memory_processes_bytes_total",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_ets_tables",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_dets_tables",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_memory_bytes_total",
        "type" => "GAUGE",
      },
      {
        "name" => "erlang_vm_memory_atom_bytes_total",
        "type" => "GAUGE",
      },
      {
        "name" => "erchef_pooler_queued_requestors_max",
        "type" => "GAUGE",
      },
      {
        "name" => "erchef_pooler_queued_requestors",
        "type" => "GAUGE",
      },
      {
        "name" => "erchef_pooler_members_max",
        "type" => "GAUGE",
      },
      {
        "name" => "erchef_pooler_members_free",
        "type" => "GAUGE",
      },
      {
        "name" => "erchef_pooler_members_in_use",
        "type" => "GAUGE",
      },
      {
        "name" => "pg_stat_n_conns",
        "type" => "GAUGE",
      },
      {
        "name" => "pg_stat_n_active_conns",
        "type" => "GAUGE",
      },
      {
        "name" => "pg_stat_tidx_blks_hit",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_tidx_blks_read",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_toast_blks_hit",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_toast_blks_read",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_idx_blks_hit",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_idx_blks_read",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_heap_blocks_hit",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_heap_blocks_read",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_n_dead_tup",
        "type" => "GAUGE",
      },
      {
        "name" => "pg_stat_n_live_tup",
        "type" => "GAUGE",
      },
      {
        "name" => "pg_stat_n_tup_del",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_n_tup_upd",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_n_tup_ins",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_tup_fetch",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_idx_scan",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_seq_tup_read",
        "type" => "COUNTER",
      },
      {
        "name" => "pg_stat_seq_scan",
        "type" => "COUNTER",
      }
    ]
  end

  let(:response_type_map) do
    Hash[response_body.map { |stat| [stat["name"], stat["type"]] }]
  end

  let(:boolean_stats) { ["erlang_vm_time_correction", "erlang_vm_threads", "erlang_vm_smp_support"] }

  # Figure out how to setup enable/disable basic-auth for test without chef-server-ctl reconfigure.
  it "returns a list of collected statistics", :smoke do
    get(request_url, platform.non_admin_user).should look_like({
      :status => 200,
      :body => response_body
    })
  end

  it "returns metrics of the correct type", :smoke do
    response = JSON.parse(get(request_url, platform.non_admin_user))
    response_type_map.each do |name, type|
      stat = response.find { |s| s["name"] == name }
      expect(stat["metrics"]).not_to be_empty
      stat["metrics"].each do |metric|
        expect(metric).to have_key("value")
        if type == "GAUGE" || type == "COUNTER"
          expect(Integer(metric["value"])).to be_a(Integer)
        elsif type == "UNTYPED" && boolean_stats.include?(name)
          expect(metric["value"]).to eq("1").or eq("0")
        else
          raise "Unimplemented test for metric type #{type}"
        end
      end
    end
  end
end
