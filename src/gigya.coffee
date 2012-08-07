###
Gigya social sharing buttons
============================

Adds social media buttons to an element decorated with data-attrs.
Requires jQuery, but will poll for it if loaded first
Supports multiple sharing contexts on one page

Usage:
<div class="share-buttons"
     data-gigya="auto"
     data-services="twitter, twitter-tweet, facebook, reddit"
     data-options="linkBack=http%3A%2F%2Fsunlightfoundation.com&amp;title=The%20Sunlight%20Foundation"
     data-twitter-tweet-options="defaultText=Check%20out%20Sunlight's%20new%20social%20media%20buttons!&amp;countURL=http%3A%2F%2Fwww.sunlightfoundation.com>
</div>
...
<script src="http://path/to/scripts/gigya.min.js"></script>

You can also manually trigger (or re-trigger) button rendering by:
- Setting data-gigya to something other than 'auto'
- Sending an event with data-gigya's value to the element
Questions? Burning rage? Direct your hatemail to <ddrinkard@sunlightfoundation.com>
###

@$ = window.jQuery
@gigya = window.gigya
@els = []
@check_count = 0
@gigya_queued = false
@service_button_img = "{% settings.ICON_BASE_URL %}/{size}/{service}.png"

check = (stuff, callback) =>
    if window.jQuery? and not window.gigya? and not @gigya_queued
        window.jQuery.getScript "//cdn.gigya.com/js/gigyaGAIntegration.js"
        window.jQuery.getScript "//cdn.gigya.com/js/socialize.js?apiKey={% settings.GIGYA_KEY %}"
        @gigya_queued = true
    checks = stuff.length
    passed_checks = 0
    if check_count > 100000
        window.console and console.log "A requirements test failed after numerous tries, aborting."
        return

    for thing in stuff
        if window[thing]?
            passed_checks++

    if passed_checks == checks
        @$ = window.jQuery
        @gigya = window.gigya
        callback()
    else
        check_count++
        window.setTimeout (()-> check(stuff, callback)), 100

    null

buttonFactory = (widget, options) =>
    options ?= {}
    button = @$.extend widget, options
    button

parseOptions = (querystring) ->
    if not querystring?
        querystring = ""
    options = querystring.split /[=&](?:amp;)?/
    hsh = {}
    for opt, i in options
        if i % 2
            hsh[options[i-1]] = window.decodeURIComponent options[i]
    hsh

init = () =>
    @$ =>
        @els = @$(".share-buttons[data-gigya]")
        @els.each (i, el) =>
            el.id or (el.id = "share_buttons_#{i + 1}")
            el = @$(el)
            if el.attr("data-gigya") == "auto"
                handle(el)
            else
                el.bind(el.attr("data-gigya"), () => handle(el))
        @els
    @els

handle = (el) =>
    ua = new @gigya.socialize.UserAction()
    services = el.attr("data-services").split(",")
    buttons = []
    params =
        containerID: el.attr("id")
        iconsOnly: true
        layout: "horizontal"
        noButtonBorder: true
        shareButtons: buttons
        shortURLs: "never"
        showCounts: "none"
        userAction: ua
    options = parseOptions el.attr("data-options")
    if options.title?
        ua.setTitle options.title
    else if (ogtitle = @$("meta[property=og\\:title]"))
        ua.setTitle ogtitle.attr("content")
    else
        ua.setTitle @$("title").text()
    if options.linkBack?
        ua.setLinkBack options.linkBack
    if options.description?
        ua.setDescription options.description
    if options.image?
        ua.addMediaItem
            type: image
            href: options.linkBack || window.location.href
            src: options.image
    if not options.size == "24"
        options.size = "16"

    for service_name in services
        service_options = {}
        service_name = service_name.replace(" ", "")
        opts_attr_name = "data-#{service_name}-options"
        service_opts = parseOptions(el.attr(opts_attr_name))
        widget =
            provider: service_name
            iconImgUp: @service_button_img.replace(
                "{service}", service_name).replace(
                "{size}", options.size)
        buttons.push buttonFactory(widget, service_options)

    @gigya.socialize.showShareBarUI @$.extend(
        params,
        options
    )

check(['jQuery', 'gigya'], init)