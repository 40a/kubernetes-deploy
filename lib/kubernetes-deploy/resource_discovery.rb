# frozen_string_literal: true

module KubernetesDeploy
  class ResourceDiscovery
    def initialize(namespace:, context:, logger:, namespace_tags:)
      @namespace = namespace
      @context = context
      @logger = logger
      @namespace_tags = namespace_tags
      @cr_mapping = {}
    end

    def crds(sync_mediator)
      sync_mediator.get_all(CustomResourceDefinition.kind).map do |r_def|
        KubernetesResource.build(namespace: @namespace, context: @context, logger: @logger,
          definition: r_def, statsd_tags: @namespace_tags)
      end
    end
  end
end
