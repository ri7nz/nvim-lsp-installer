local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local std = require "nvim-lsp-installer.installers.std"
local context = require "nvim-lsp-installer.installers.context"

return function(name, root_dir)
    return server.Server:new {
        name = name,
        root_dir = root_dir,
        languages = { "groovy" },
        homepage = "https://github.com/GroovyLanguageServer/groovy-language-server",
        installer = {
            std.ensure_executables { { "javac", "javac was not found in path." } },
            std.git_clone "https://github.com/GroovyLanguageServer/groovy-language-server",
            context.promote_install_dir(),
            std.gradlew {
                args = { "build" },
            },
            context.receipt(function(receipt, ctx)
                receipt:with_primary_source(
                    receipt.git_remote(
                        "https://github.com/GroovyLanguageServer/groovy-language-server",
                        ctx.requested_server_version
                    )
                )
            end),
        },
        default_options = {
            cmd = { "java", "-jar", path.concat { root_dir, "build", "libs", "groovyls-all.jar" } },
        },
    }
end
