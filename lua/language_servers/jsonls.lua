local schemas = require('schemastore').json.schemas()

-- print(vim.inspect(schemas))

-- schemas['.swcrc'] = {
--   description = 'swc configuration file',
--   fileMatch = { '**/.swcrc' },
--   name = 'swcrc',
--   url = 'https://swc.rs/schema.json',
-- }

return {
  settings = {
    json = {
      schemas = schemas,
      validate = { enable = true },
    },
  },
}
