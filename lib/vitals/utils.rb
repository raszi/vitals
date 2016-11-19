module Vitals
  module Utils
    BAD_METRICS_CHARS = Regexp.compile('[\/\-:\s]').freeze
    SEPARATOR = '.'.freeze
    def self.normalize_metric(m)
      m.gsub(BAD_METRICS_CHARS, '_')
    end
    def self.hostname
      `hostname -s`.chomp
    end
    def self.sec_to_ms(sec)
      (1000.0 * sec).round
    end
    # XXX grape specific, move this away some day?
    def self.grape_path(route)
      version = route.respond_to?(:version) ? route.version : route.route_version
      route_path = route.respond_to?(:path) ? route.path : route.route_path
      path = route_path.dup[1..-1]          # /foo/bar/baz -> foo/bar/baz
      path.sub!(/\(\..*\)$/, '')                  # (.json) -> ''
      path.sub!(":version", version) if version   # :version -> v1
      path.gsub!(/\//, self.path_sep)     # foo/bar -> foo.bar
      path
    end

    def self.path_sep
      @path_sep
    end

    def self.path_sep=(val)
      @path_sep = val
    end
  end
end
