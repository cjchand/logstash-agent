# How to Upload the Dashboard

In the `./kibana` directory is a JSON file that defines all of the searches, visualizations, and the dashboard that uses the grok patterns contained within this repo. 

Once you have Apache logs flowing into ElasticSearch - and have them parsed by Logstash (or an ES pipeline) - using the included Grok patterns, you can add this dashboard to your Kibana by:

1. Log into Kibana
2. Click on the "Management" icon (the one that looks like a gear)
3. Click "Saved Objects"
4. Click "Import"
5. In the dialog that pops up, navigate to the `./kibana` directory and select the JSON file

# How to Access the Dashboard

Once uploaded, you can get to the Dashboard by doing the following:

1. Log into Kibana
2. Click the "Dashboards" icon (the one that looks like a gauge)
3. At the top of the page, click "Open", then choose "Apache Overview"


