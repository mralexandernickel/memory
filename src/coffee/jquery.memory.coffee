$ = jQuery

config =
  container: null
  total_cards: 25
  images_url: "images.json"
  images: null
  cards_needed: 2
  card_pairs: 32

methods =
  init: (options) ->
    # set the container
    config.container = $(this)
    # set options
    $.extend config, options
    
    methods.dev_get_images()
  
  dev_get_images: ->
    images = [
      "assets/card_images/card_01.jpg",
      "assets/card_images/card_02.jpg",
      "assets/card_images/card_03.jpg",
      "assets/card_images/card_04.jpg",
      "assets/card_images/card_05.jpg",
      "assets/card_images/card_06.jpg",
      "assets/card_images/card_07.jpg",
      "assets/card_images/card_08.jpg",
      "assets/card_images/card_09.jpg",
      "assets/card_images/card_10.jpg",
      "assets/card_images/card_11.jpg",
      "assets/card_images/card_12.jpg",
      "assets/card_images/card_13.jpg",
      "assets/card_images/card_14.jpg",
      "assets/card_images/card_15.jpg",
      "assets/card_images/card_16.jpg",
      "assets/card_images/card_17.jpg",
      "assets/card_images/card_18.jpg",
      "assets/card_images/card_19.jpg",
      "assets/card_images/card_20.jpg",
      "assets/card_images/card_21.jpg",
      "assets/card_images/card_23.jpg",
      "assets/card_images/card_24.jpg",
      "assets/card_images/card_25.jpg",
      "assets/card_images/card_26.jpg",
      "assets/card_images/card_28.jpg",
      "assets/card_images/card_31.jpg",
      "assets/card_images/card_32.jpg"
    ]
    config.images = images.concat images
    config.images = methods.shuffle config.images
    methods.build_deck()
  
  # get images for the cards  
  get_images: ->
    $.get config.images_url, (images) ->
      config.images = images.concat images
      config.images = methods.shuffle config.images
      methods.build_deck()
  
  # create and insert the card deck
  build_deck: ->
    for image in config.images
      card = $("<div class=\"card\"><span></span><span class=\"back\" style=\"background-image: url(#{image});\"></span></div>")
      card.click (e) ->
        e.preventDefault()
        methods.play_card this
      config.container.append card
  
  # playing a card
  play_card: (card) ->
    $(card).addClass "card-selected"
    if $(".card-selected").length == config.cards_needed
      methods.check_equality()
  
  # check played cards for equality
  check_equality: ->
    cards = $(".card-selected")
    first_image = $(cards[0]).children("span.back").attr "style"
    all_the_same = false
    for card in cards
      if $(card).children("span.back").attr("style") is first_image
        # card is the same
        all_the_same = true
      else
        # card is not the same
        all_the_same = false
        break
    if all_the_same is true
      methods.remove_played_cards cards
    else
      methods.reset_played_cards cards
  
  # removing played and equal cards
  remove_played_cards: (cards) ->
    cards.addClass "animated rollOut"
    methods.reset_played_cards cards
  
  # resetting played but not equal cards
  reset_played_cards: (cards) ->
    window.setTimeout ->
      cards.removeClass "card-selected"
    , 1000
  
  # helper method to shuffle an array
  #
  # Adapted from the javascript implementation at http://sedition.com/perl/javascript-fy.html
  shuffle: (arr) ->
    i = arr.length
    while --i > 0
      j = ~~(Math.random() * (i + 1))
      t = arr[j]
      arr[j] = arr[i]
      arr[i] = t
    arr

$.fn.memory = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in memory game"