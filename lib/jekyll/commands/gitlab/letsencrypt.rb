module Jekyll
  module Commands
    module Gitlab
      class Letsencrypt < ::Jekyll::Command
        def self.init_with_program(prog)
          prog.command(:letsencrypt) do |c|
            c.description "Setup/Renew letsencrypt certificate"

            c.action do |_args, _opts|
              Jekyll::Gitlab::Letsencrypt::Process.process!
            end
          end
        end
      end
    end
  end
end
