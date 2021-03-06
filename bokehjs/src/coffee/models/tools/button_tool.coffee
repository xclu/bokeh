_ = require "underscore"
Backbone = require "backbone"
Tool = require "./tool"
button_tool_template = require "./button_tool_template"

class ButtonToolButtonView extends Backbone.View
  tagName: "li"
  template: button_tool_template

  events: () ->
    # TODO (bev) this seems to work OK but maybe there is a better way
    if 'ontouchstart' of document
      return { 'touchstart .bk-toolbar-button': '_clicked' }
    else
      return { 'click .bk-toolbar-button': '_clicked' }

  initialize: (options) ->
    super(options)
    @$el.html(@template(@model.attrs_and_props()))
    @listenTo(@model, 'change:active', () => @render())
    @listenTo(@model, 'change:disabled', () => @render())
    @render()

  render: () ->
    @$el.children('button')
        .prop("disabled", @model.get('disabled'))
        .toggleClass('active', @model.get('active'))
    return @

  _clicked: (e) ->

class ButtonToolView extends Tool.View

class ButtonTool extends Tool.Model

  initialize: (attrs, options) ->
    super(attrs, options)
    @register_property('tooltip', () ->@get('tool_name'))

  nonserializable_attribute_names: () ->
    super().concat(['icon', 'disabled'])

  defaults: () ->
    return _.extend({}, super(), {
      active: false
      disabled: if @disabled? then @disabled else false
      tool_name: @tool_name
      icon: @icon
    })

module.exports =
  Model: ButtonTool
  View: ButtonToolView
  ButtonView: ButtonToolButtonView
