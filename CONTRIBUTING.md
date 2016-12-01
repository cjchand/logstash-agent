# Contributing to the OAP Logging Marketplace

All of the pre-built parsers, visualizations, and dashboards that are available in the OAP Logging Portal live in this repo.

We **highly** encourage submissions from anyone, anywhere. Before you submit, however, there is a standard format and procedure that must be adhered to in order to ensure your hard work can be enjoied by others!

# Branching

Each new parser/dashboard pair needs to live in a separate branch following this naming convention:

`feature/XXXX-parser`, where "XXXX" is the display name you wish to show in the Portal UI when users choose what parsers they want to deploy. For example, the `feature/apache-parser` branch would show up as "apache" in the Marketplace in the OAP Logging Portal.

# Directory Structure

We shoot for providing not just the OAP community with the fruits of your labor, but we want to give back to the ELK community at-large. Because of this, we encourage sharing your parsers in Logstash-compatible format in the following directory (off of the root of the repo):

`/config/logstash/conf.d`

This would contain - at least - the Logstash `filter { mutate { grok } } } ` configuration needed for a Logstash client to use your Grok pattern(s). 

While the above is optional for contributions, the following directories must be present, with the appopriate content:

* **/kibana**: This will hold the Kibana dashboard, as well as any search and visualization definitions the dashboard requires. This can be in one or more files, as long as they end in `.json`
* **/pipeline**: Technically optional, as it references an ES 5.x only feature, but highly preferred. Contains a JSON definition for an ES Grok Pattern Processor. This will be HTTP PUT'ed to the Ingest node as a pipeline. The name of the file will be used as the name of the pipeline (e.g.: the contents of the file `asa-parser.json` will be submitted as `http://my_es_server:9200/_ingest/pipeline/asa-parser`
* **/docs**: Self-explanatory, but this is a section to put Markdown files that help users understand your dashboards, visualization, etc. (Still TBD, but the intent is to either embed these in the Portal or to upload them as Markdown panes in Kibana that can be linked to from the Portal and/or Kibana).
* **/mappings**: JSON file(s) containing ES mapping definitions, as the dashboards will throw errors if the field(s) they require are not present. This will happen if the target logging hasn't been pushed into the platform yet.