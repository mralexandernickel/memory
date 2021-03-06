(function() {
  $(function() {
    return $(".deck").memory();
  });

}).call(this);
(function() {
  var $, config, methods,
    __slice = [].slice;

  $ = jQuery;

  config = {
    container: null,
    total_cards: 25,
    images_url: "images.json",
    images: null,
    cards_needed: 2,
    card_pairs: 32
  };

  methods = {
    init: function(options) {
      config.container = $(this);
      $.extend(config, options);
      return methods.dev_get_images();
    },
    dev_get_images: function() {
      var images;
      images = ["assets/card_images/card_01.jpg", "assets/card_images/card_02.jpg", "assets/card_images/card_03.jpg", "assets/card_images/card_04.jpg", "assets/card_images/card_05.jpg", "assets/card_images/card_06.jpg", "assets/card_images/card_07.jpg", "assets/card_images/card_08.jpg", "assets/card_images/card_09.jpg", "assets/card_images/card_10.jpg", "assets/card_images/card_11.jpg", "assets/card_images/card_12.jpg", "assets/card_images/card_13.jpg", "assets/card_images/card_14.jpg", "assets/card_images/card_15.jpg", "assets/card_images/card_16.jpg", "assets/card_images/card_17.jpg", "assets/card_images/card_18.jpg", "assets/card_images/card_19.jpg", "assets/card_images/card_20.jpg", "assets/card_images/card_21.jpg", "assets/card_images/card_23.jpg", "assets/card_images/card_24.jpg", "assets/card_images/card_25.jpg", "assets/card_images/card_26.jpg", "assets/card_images/card_28.jpg", "assets/card_images/card_31.jpg", "assets/card_images/card_32.jpg"];
      config.images = images.concat(images);
      config.images = methods.shuffle(config.images);
      return methods.build_deck();
    },
    get_images: function() {
      return $.get(config.images_url, function(images) {
        config.images = images.concat(images);
        config.images = methods.shuffle(config.images);
        return methods.build_deck();
      });
    },
    build_deck: function() {
      var card, image, _i, _len, _ref, _results;
      _ref = config.images;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        image = _ref[_i];
        card = $("<div class=\"card\"><span></span><span class=\"back\" style=\"background-image: url(" + image + ");\"></span></div>");
        card.click(function(e) {
          e.preventDefault();
          return methods.play_card(this);
        });
        _results.push(config.container.append(card));
      }
      return _results;
    },
    play_card: function(card) {
      $(card).addClass("card-selected");
      if ($(".card-selected").length === config.cards_needed) {
        return methods.check_equality();
      }
    },
    check_equality: function() {
      var all_the_same, card, cards, first_image, _i, _len;
      cards = $(".card-selected");
      first_image = $(cards[0]).children("span.back").attr("style");
      all_the_same = false;
      for (_i = 0, _len = cards.length; _i < _len; _i++) {
        card = cards[_i];
        if ($(card).children("span.back").attr("style") === first_image) {
          all_the_same = true;
        } else {
          all_the_same = false;
          break;
        }
      }
      if (all_the_same === true) {
        return methods.remove_played_cards(cards);
      } else {
        return methods.reset_played_cards(cards);
      }
    },
    remove_played_cards: function(cards) {
      cards.addClass("animated rollOut");
      return methods.reset_played_cards(cards);
    },
    reset_played_cards: function(cards) {
      return window.setTimeout(function() {
        return cards.removeClass("card-selected");
      }, 1000);
    },
    shuffle: function(arr) {
      var i, j, t;
      i = arr.length;
      while (--i > 0) {
        j = ~~(Math.random() * (i + 1));
        t = arr[j];
        arr[j] = arr[i];
        arr[i] = t;
      }
      return arr;
    }
  };

  $.fn.memory = function() {
    var method, options;
    method = arguments[0], options = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (methods[method]) {
      return methods[method].apply(this, options);
    } else if (typeof method === "object" || !method) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error("Method " + method + " does not exist in memory game");
    }
  };

}).call(this);
