Polymer
  is: '#GRUNT_COMPONENT_NAME'

  getImage: (cell, attire)->
    attire?.rules
      .filter(
        (rule) => @_doesSatisfyRule cell, rule
      )[0]?.image

  _doesSatisfyRule: (cell, rule) ->
    itSatisfies = (color) =>
      @_doesSatisfyQuantity cell[color], rule.when[color]

    ["red", "blue", "green", "black"]
    .reduce((previousCondition, color) =>
      previousCondition and itSatisfies color
    , true)

  _doesSatisfyQuantity: (quantity = 0, expectedQuantity) ->
    switch expectedQuantity
      when "*"
        true
      when "+"
        quantity > 0
      else
        quantity is expectedQuantity
