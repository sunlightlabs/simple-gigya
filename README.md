## Simple Gigya

A simple javascript file to include social sharing buttons via a single container element in HTML

### Requirements:

This script will handle the fetching of the gigya code, but expects to find
jQuery on your page. It won't complain if not found, just fail silently after
polling for a while.

### Building the JS:

Gigya requires an API key, and this implementation assumes you want
to host your own sharing icons at a specified location,
`"#{settings.ICON_BASE_URL}/#{size}/#{service_name}.png"`.

The output of the build process will be a script configured for both of those
variables, as supplied in `settings.coffee`.

1. Make sure you have Node.js and NPM
2. Check this repo out to a local working copy
3. Run `npm install` from within that folder
4. Run `cp settings.coffee.example settings.coffee` (and fill out the 2 variables)
5. Run `cake build`

### Usage:
    <div class="share-buttons"
         data-gigya="auto"
         data-services="twitter, twitter-tweet, facebook, reddit"
         data-options="linkBack=http%3A%2F%2Fsunlightfoundation.com&amp;title=The%20Sunlight%20Foundation"
         data-twitter-tweet-options="defaultText=Check%20out%20Sunlight's%20new%20social%20media%20buttons!&amp;countURL=http%3A%2F%2Fwww.sunlightfoundation.com">
    </div>
    ...
    <script src="http://path/to/scripts/gigya.min.js"></script>

### That's It!
Put the .js or .min.js file on your server and include as in the example above.

You can also manually trigger (or re-trigger) button rendering by:
- Setting data-gigya to something other than 'auto'
- Sending an event with data-gigya's value to the element
