// Load Gulp Plugins
var argv 		= require('yargs').argv,
	gulp        = require('gulp'),
    eventstream = require('event-stream'),
    path        = require('path');
    sass        = require('gulp-ruby-sass'),
    rename      = require('gulp-rename'),
    minifycss   = require('gulp-minify-css'),
    uglify      = require('gulp-uglify'),
    concat      = require('gulp-concat'),
    notify      = require('gulp-notify'),
    clean       = require('gulp-clean'),
    zip         = require('gulp-zip');

// Compile scss Files
gulp.task('scss', function() {
    return gulp.src('dev/src/scss/ghostion.scss')
        .pipe(sass({style: 'expanded', quiet: true, cacheLocation: 'dev/src/scss/.sass-cache'}))
        .pipe(gulp.dest('dev/dest/css'))
        .pipe(minifycss())
        .pipe(rename({suffix: '.min'}))
        .pipe(gulp.dest('packages/theme/assets/css'))
        .pipe(notify({message: 'SCSS Files Compiled Successfully'}));
});

// Concat JS Files
gulp.task('concat', function() {
    return gulp.src([
            'dev/src/framework/foundation/js/vendor/modernizr.js',
            'dev/src/framework/foundation/js/foundation/foundation.js',
            'dev/src/framework/foundation/js/foundation/foundation.alert.js',
            'dev/src/framework/foundation/js/foundation/foundation.offcanvas.js',
            'dev/src/framework/foundation/js/foundation/foundation.reveal.js',
            'dev/src/framework/foundation/js/foundation/foundation.tooltip.js',
            'dev/src/js/*.js'])
        .pipe(concat('ghostion.js'))
        .pipe(gulp.dest('dev/dest/js'))
        .pipe(uglify())
        .pipe(rename({suffix: '.min'}))
        .pipe(gulp.dest('packages/theme/assets/js'))
        .pipe(notify({message: 'JavaScript Files Compiled & Compressed Successfully'}));
});

// Watch scss and JS Files
gulp.task('watch', function() {
    gulp.watch('dev/src/scss/**/*.scss', ['scss']);
    gulp.watch('dev/src/js/*.js', ['concat']);
});

// Zip Build Packages Files
gulp.task('zip_build', function() {
    return eventstream.concat (
        // Zip Theme Files
        gulp.src('**', {cwd: path.join(process.cwd(), 'packages/theme')})
            .pipe(zip('the-ghost-who-blogs-' + argv.buildversion + '.zip'))
            .pipe(gulp.dest('dev/tmp/theme'))
    );
});

// Zip Release Packages Files
gulp.task('zip_release', function() {
    return eventstream.concat (
        // Zip Theme Files
        gulp.src('**', {cwd: path.join(process.cwd(), 'packages/theme')})
            .pipe(zip('the-ghost-who-blogs-' + argv.releaseversion + '.zip'))
            .pipe(gulp.dest('dev/tmp/theme'))
    );
});

// Clean tmp Files
gulp.task('clean_tmp', function() {
    gulp.src('dev/tmp', {read: false})
        .pipe(clean());
});

// Clean Build Files
gulp.task('clean_builds', function() {
    gulp.src('builds/**', {read: false})
        .pipe(clean());
});

// Clean Releases Files
gulp.task('clean_releases', function() {
    gulp.src('releases/**', {read: false})
        .pipe(clean());
});

// Move Zip Files to builds Folder
gulp.task('move_zip_build', ['clean_builds'], function() {
    gulp.src('dev/tmp/**/*.zip')
        .pipe(gulp.dest('builds'))
        .pipe(notify({message: 'All Files Built Successfully'}));
});

// Move Zip Files to releases Folder
gulp.task('move_zip_release', ['clean_releases'], function() {
    gulp.src('dev/tmp/**/*.zip')
        .pipe(gulp.dest('releases'))
        .pipe(notify({message: 'All Files Released Successfully'}));
});

// Main Task: Develop
gulp.task('develop', function() {
    gulp.start('scss', 'concat', 'watch');
});

// Main Task: Build
gulp.task('build', ['zip_build'], function() {
    gulp.start('move_zip_build', 'clean_tmp');
});

// Main Task: Release
gulp.task('release', ['zip_release'], function() {
    gulp.start('move_zip_release', 'clean_tmp');
});