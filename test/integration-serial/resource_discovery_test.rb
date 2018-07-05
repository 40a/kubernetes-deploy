# frozen_string_literal: true
require 'test_helper'

class ResourceDiscoveryTest < KubernetesDeploy::IntegrationTest
  def test_non_prunable_crd_no_predeploy
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["shredders.yml"]))
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["shredders_cr.yml"]))
    # Deploy any other non-priority (predeployable) resource to trigger pruning
    assert_deploy_success(deploy_fixtures("hello-cloud", subset: ["daemon_set.yml"]))

    refute_logs_match("The following resources were pruned: widget \"my-first-shredder\"")
  end

  def test_prunable_crd_with_predeploy
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["widgets.yml", "shredders.yml"]))
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["widgets_cr.yml"]))
    # Deploy any other resource to trigger pruning
    assert_deploy_success(deploy_fixtures("hello-cloud", subset: ["configmap-data.yml",]))
    assert_logs_match("The following resources were pruned: widget \"my-first-widget\"")
  end
end
