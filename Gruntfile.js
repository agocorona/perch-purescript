module.exports = function(grunt) {

  "use strict";

  grunt.initConfig({

    srcFiles: ["src/**/*.purs", "bower_components/**/src/**/*.purs"],

    psc: {
      options: {
        main: "Main",
        modules: ["Perch"]
      },

    }
  });

  grunt.loadNpmTasks("grunt-purescript");

  grunt.registerTask("default", []);
};
