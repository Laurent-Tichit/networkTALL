#!/usr/bin/python3

import graph_tool.all as gt
import matplotlib
import os, pathlib

def main():
	g = gt.load_graph_from_csv("data/HI-union.tsv", csv_options={'delimiter': '\t'})

	v_distrib, ri = gt.graph_tool.centrality.pagerank(g, damping=0.999, epsilon=1e-9, max_iter=g.num_edges(), ret_iter=True)
	print(ri)

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
				output="RW_HI-union.pdf")

	f = open("RW_HI-union.tsv", "w")
	for v in g.iter_vertices():
		print(f"{g.vp.name[v]}\t{g.vp.v_distrib[v]:.9f}", file=f)
	

if __name__ == "__main__":
	# change this line to suit your needs
	rwrd = "sync/Recherche/AnnieNguyen/networkTALL/misc_code/RWR"

	wd = os.getcwd()
	hd = pathlib.Path.home()
	abs_rwrd = os.path.join(hd, rwrd)
	print("Working directory is:", wd)
	print("Home directory is:", hd)
	print("Changing directory to:", abs_rwrd)
	os.chdir(abs_rwrd)
	main()
