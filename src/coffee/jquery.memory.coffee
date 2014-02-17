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
      "http://lorempixel.com/80/80"
      "http://lorempixel.com/90/90"
      "http://lorempixel.com/100/100"
      "http://lorempixel.com/110/110"
      "http://lorempixel.com/120/120"
      "http://lorempixel.com/130/130"
      "http://lorempixel.com/140/140"
      "http://lorempixel.com/150/150"
      "http://lorempixel.com/160/160"
      "http://lorempixel.com/170/170"
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
  
  play_card: (card) ->
    $(card).addClass "card-selected"
    if $(".card-selected").length == config.cards_needed
      methods.check_equality()
  
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
  
  remove_played_cards: (cards) ->
    cards.addClass "animated rollOut"
    methods.reset_played_cards cards
  
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