import js from "@eslint/js";

export default [
  {
    files: ["**/*.js"], 
    languageOptions: {
      sourceType: "commonjs",
      ecmaVersion: 2022,
      // Au lieu d'importer globals, définissez manuellement les globals dont vous avez besoin
      globals: {
        // Browser globals
        window: "readonly",
        document: "readonly",
        navigator: "readonly",
        // Jest globals
        describe: "readonly",
        test: "readonly",
        expect: "readonly",
        it: "readonly",
        jest: "readonly",
        beforeEach: "readonly",
        afterEach: "readonly",
        beforeAll: "readonly",
        afterAll: "readonly",
        // Node.js globals
        __dirname: "readonly", 
        __filename: "readonly", 
        process: "readonly",
        require: "readonly",
        module: "readonly",
        exports: "readonly",
        console: "readonly",
      },
    },
  },
  js.configs.recommended,
  {
    ignores: ['app/tests/**', 'docs/**'],
  }
];