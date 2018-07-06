# frozen_string_literal: true
require 'test_helper'

class ResourceDiscoveryTest < KubernetesDeploy::IntegrationTest
  def test_non_prunable_crd
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["shredders.yml"]))
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["shredders_cr.yml"]))
    # Deploy any other non-priority (predeployable) resource to trigger pruning
    assert_deploy_success(deploy_fixtures("hello-cloud", subset: ["configmap-data.yml"]))

    refute_logs_match("The following resources were pruned: widget \"my-first-shredder\"")
  end

  def test_prunable_crd
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["widgets.yml"]))
    assert_deploy_success(deploy_fixtures("resource-discovery", subset: ["widgets_cr.yml"]))
    # Deploy any other resource to trigger pruning
    assert_deploy_success(deploy_fixtures("hello-cloud", subset: ["configmap-data.yml"]))
    assert_logs_match("The following resources were pruned: widget \"my-first-widget\"")
    assert_logs_match("Pruned 1 resource and successfully deployed 1 resource")
  end
end
