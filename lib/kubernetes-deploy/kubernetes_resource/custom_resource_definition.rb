# frozen_string_literal: true
module KubernetesDeploy
  class CustomResourceDefinition < KubernetesResource
    TIMEOUT = 30.seconds

    def deploy_succeeded?
      names_accepted_status == "True"
    end

    def deploy_failed?
      names_accepted_status == "False"
    end

    def timeout_message
      UNUSUAL_FAILURE_MESSAGE
    end

    def plural_name
      @definition.dig("spec", "names", "plural")
    end

    def kind
      @definition.dig("spec", "names", "kind")
    end

    def prunable?
      @definition.dig("metadata", "annotations", "kubernetes-deploy.shopify.io/metadata", "prunable") == "true"
    end

    def predeployable?
      @definition.dig("metadata", "annotations", "kubernetes-deploy.shopify.io/metadata", "predeploy") == "true"
    end

    private

    def names_accepted_status
      conditions = @instance_data.dig("status", "conditions") || []
      names_accepted = conditions.detect { |c| c["type"] == "NamesAccepted" } || {}
      names_accepted["status"]
    end
  end
end
