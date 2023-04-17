#!/usr/bin/python3

import graph_tool.all as gt
import matplotlib

def main():
	g = gt.load_graph_from_csv("../data/HI-union.tsv", csv_options={'delimiter': '\t'})
	print(g.vp.name)
	
	print(g.num_vertices())
	v_distrib, ri = gt.graph_tool.centrality.pagerank(g, damping=1, epsilon=1e-04, max_iter=g.num_edges(), ret_iter=True)
	print(v_distrib)
	g.vp.v_distrib = v_distrib

	
	pos = gt.sfdp_layout(g)
	gt.graph_draw(g,
				pos,
				output_size=(1080, 1080),
				vertex_color=[1,1,1,0],
				vertex_fill_color=v_distrib,
				vertex_size=1,
				edge_pen_width=1.2,
				vcmap=matplotlib.cm.gist_heat_r,
				output="huRI.pdf")

	f = open("node_scores.tsv", "w")
	for v in g.iter_vertices():
		print(f"{g.vp.name[v]}\t{g.vp.v_distrib[v]:.6f}", file=f)
	

if __name__ == "__main__":
	main()
