# frozen_string_literal: true
module KubernetesDeploy
  class HorizontalPodAutoscaler < KubernetesResource
    PRUNABLE = true
    TIMEOUT = 30.seconds

    def deploy_succeeded?
      conditions = @instance_data.dig("status", "conditions") || []
      able_to_scale = conditions.detect { |c| c["type"] == "AbleToScale" } || {}
      able_to_scale["status"] == "True"
    end

    def deploy_failed?
      !exists?
    end

    def timeout_message
      UNUSUAL_FAILURE_MESSAGE
    end

    def type
      'hpa.v2beta1.autoscaling'
    end
  end
end
