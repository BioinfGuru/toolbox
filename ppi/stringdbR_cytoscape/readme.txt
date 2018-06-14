Install 2 versions of cytoscape	the latest (version 3.6) as well as version 2.8.3 
Only version 2.8 allows you to convert nodes into pie charts (very useful)

# Create network
	- Cytoscape 3.6 --> Install:
		- stringapp:	http://apps.cytoscape.org/apps/stringApp
		- yFiles:		http://apps.cytoscape.org/apps/yfileslayoutalgorithms
	- Create network:		http://jensenlab.org/training/stringapp/ --> section 2.1 "protein network retreival"
		- File --> Import --> Network --> Public Databases --> Data Source: "String: protein query" --> Organism: Mus musculus --> paste ensembl ids
		- Confidence cutoff: 0.9
		- Max additional interactors: 0
		- Import (Ignore possible matches)
		- Delete unconnected nodes
	- File --> export --> network --> formats: xgmml --> ok
	- Set style:
		- VizMapper --> current visual style --> /NGS/users/Kenneth/ppi_plotting/stringdbR_cytoscape/myStyle.props
		- node label --> display name --> passthrough mapper
	- Create required attribute files
	- Load attribute files:  file --> import --> attributes from table (text/excel) --> Attributes: Node --> select attribute file

# Convert nodes to Pie charts
	- This can only be done in cytoscape 2 with a network first created in cytoscape 3 and stored as an xgmml file
	- Install
			MultiColouredNodes:	https://sourceforge.net/projects/multicolor/
			Mcode:				http://apps.cytoscape.org/apps/mcode
	- Create required attribute file: /NGS/users/Kenneth/ppi_plotting/stringdbR_cytoscape/makePieChartAttributeFile.pl
	- File --> import:
		- network:		network multiple file types --> load xgmml (created by cytoscape 3)
		- style:		as above
		- attributes:	file --> import --> attributes from table (text/excel) --> Attributes: Node --> select attribute file
						show text file import options --> delimiter: tab --> atribute names: tick box "Transfer first..."
						show mapping options --> annotation primary key: query_name --> key attribute for network: query term
						import
	- color nodes --> attribute based coloring --> choose attributes to base coloring on (M1, M2, M3) --> ok
	- for each attribute you added --> select a color for each possible value --> ok

# Clustering
	- Install MCODE:	http://apps.cytoscape.org/apps/mcode
	- plugin --> MCODE --> analyze (default settings)
	- Experiment with layouts to emphasize clusters
	- Select a cluster:
		- Expanding the size threshold include more genes around the cluster but reduces the score (cost/benefit balance)
		- Once optimal size + score found --> create sub-network
		- Redo node colors
		- Move overlapping nodes
		- Export network as graphic --> png --> zoom 500%, res 600dpi
		- select all --> view query term in display panel --> R click --> export entire table as cluster1.txt
		- cut -f 2 cluster1.txt | sed '/^query/d' >cluster1.list; rm cluster1.txt

# GSEA
	- https://biit.cs.ut.ee/gprofiler/index.cgi
	- Settings:	significant only, no electronic GO annotations, hierarchical sorting off, all 3 gene ontology, both biological pathways
	