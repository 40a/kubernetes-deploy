# frozen_string_literal: true
module KubernetesDeploy
  class CustomResource < KubernetesResource
    TIMEOUT = 1.minutes

    def deploy_succeeded?
      exists?
    end

    def deploy_failed?
      false
    end
  end
end
