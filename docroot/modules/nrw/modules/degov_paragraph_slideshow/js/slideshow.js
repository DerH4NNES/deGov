/**
 * @file slideshow.js
 *
 * Defines the behavior of the Slideshow paragraph.
 */
(function ($, Drupal, drupalSettings) {

  'use strict';

  /**
   * Initializes the slideshow paragraph with Slick.
   */
  Drupal.behaviors.slideshow = {
    attach: function (context, settings) {
      $('.slideshow.default .slideshow__slides').once().slick({
        dots: true,
        autoplay: true
      });

      // Slick slider for prev/next thumbnails images
      $('.slideshow-with-prev-next .slides_prev_next').once().slick({
        dots: true,
        slidesToShow: 1,
        autoplay: false
      });
      setTimeout(function () {
        $('.slideshow-with-prev-next .slides_prev_next').prepend('<div class="prev-slick-img slick-thumb-nav"><img src="/prev.jpg" class="img-responsive"></div>').append('<div class="next-slick-img slick-thumb-nav"><img src="/next.jpg" class="img-responsive"></div>');
        get_prev_slick_img();
        get_next_slick_img();
      }, 500);

      $('.slides_prev_next').on('click', '.slick-prev', function () {
        get_prev_slick_img();
      });
      $('.slides_prev_next').on('click', '.slick-next', function () {
        get_next_slick_img();
      });
      $('.slideshow-with-prev-next .slides_prev_next').on('swipe', function (event, slick, direction) {
        if (direction == 'left') {
          get_prev_slick_img();
        }
        else {
          get_next_slick_img();
        }
      });

      function get_prev_slick_img() {
        // For prev img
        var prev_slick_img = $('.slick-current').prev('.slide').find('.slide__media img').attr('src');
        $('.prev-slick-img img').attr('src', prev_slick_img);
        $('.prev-slick-img').css('background-image', 'url(' + prev_slick_img + ')');
        // For next img
        var prev_next_slick_img = $('.slick-current').next('.slide').find('.slide__media img').attr('src');
        $('.next-slick-img img').attr('src', prev_next_slick_img);
        $('.next-slick-img').css('background-image', 'url(' + prev_next_slick_img + ')');
      }

      function get_next_slick_img() {
        // For next img
        var next_slick_img = $('.slick-current').next('.slide').find('.slide__media img').attr('src');
        $('.next-slick-img img').attr('src', next_slick_img);
        $('.next-slick-img').css('background-image', 'url(' + next_slick_img + ')');
        // For prev img
        var next_prev_slick_img = $('.slick-current').prev('.slide').find('.slide__media img').attr('src');
        $('.prev-slick-img img').attr('src', next_prev_slick_img);
        $('.prev-slick-img').css('background-image', 'url(' + next_prev_slick_img + ')');
      }

      $('.slick__pause').on('click', function () {
        $('.slideshow__slides').once().slick('slickPause');
        $(this).hide().siblings('.slick__play').show();
      });
      $('.slick__play').on('click', function () {
        $('.slideshow__slides').once().slick('slickPlay');
        $(this).hide().siblings('.slick__pause').show();
      });
      // End
    }
  }

})(jQuery, Drupal, drupalSettings);