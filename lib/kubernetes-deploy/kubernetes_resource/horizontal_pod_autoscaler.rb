# frozen_string_literal: true
module KubernetesDeploy
  class HorizontalPodAutoscaler < KubernetesResource
    TIMEOUT = 30.seconds

    def deploy_succeeded?
      able_to_scale_condition["status"] == "True"
    end

    def deploy_failed?
      return false unless exists?
      able_to_scale_condition["status"] == "False"
    end

    def type
      'hpa.v2beta1.autoscaling'
    end

    def status
      if !exists?
        super
      elsif deploy_succeeded?
        "Succeeded"
      else
        able_to_scale_condition["reason"]
      end
    end

    private

    def able_to_scale_condition
      conditions = @instance_data.dig("status", "conditions") || []
      conditions.detect { |c| c["type"] == "AbleToScale" } || {}
    end
  end
end
