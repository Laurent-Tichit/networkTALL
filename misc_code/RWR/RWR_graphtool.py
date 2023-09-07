#!/usr/bin/env python3

import graph_tool.all as gt

# import matplotlib
import csv, os

# import pathlib


def rwr(network_file, weights_file, outfile):
    # should be a 2-column CSV of edges list. And edge is a pair of nodes.
    g = gt.load_graph_from_csv(network_file, csv_options={"delimiter": "\t"})

    # create dict, to be able to get node object from node name
    name2node = {}
    for v in g.iter_vertices():
        name2node[g.vp.name[v]] = v

    # read weights file and add to graphs as pers property (personalized)
    with open(weights_file, "r") as f:
        csv_reader = csv.reader(f, delimiter="\t")
        list_of_rows = list(csv_reader)
    g.vp.pers = g.new_vertex_property("double")
    for name, weight in list_of_rows:
        n = name2node[name]
        g.vp.pers[n] = weight

    # returns the distribution vector, and the number of iterations done
    v_distrib, nb_iter = gt.graph_tool.centrality.pagerank(
        g,
        pers=g.vp.pers,
        damping=0.95,
        epsilon=1e-09,
        max_iter=g.num_edges(),
        ret_iter=True,
    )

    print(f"{nb_iter} iterations done")
    # adds the vector distribution to the graph (so that if we save the graph, the node values will be saved)
    g.vp.v_distrib = v_distrib

    # # drawing (optional)
    # gt.graph_draw(g,
    # 			pos = gt.sfdp_layout(g),
    # 			output_size=(1080, 1080),
    # 			vertex_color=[1,1,1,0],
    # 			vertex_fill_color=v_distrib,
    # 			vertex_size=1,
    # 			edge_pen_width=1.2,
    # 			vcmap=matplotlib.cm.gist_heat_r,
    # 			output="weighted_PPI.pdf")

    # save the vector distribution to file
    with open(outfile, "w") as f:
        for v in g.iter_vertices():
            print(f"{g.vp.name[v]}\t{g.vp.v_distrib[v]:.9f}", file=f)


if __name__ == "__main__":
    # change this line to suit your needs
    rwrd = "."

    # input network file
    network_file = os.path.join(
        rwrd, "data/PPI_HiUnion_LitBM_APID_gene_names_190123.tsv"
    )

    # input weights file: weigths are either binary (0 or 1) or "-log(p-value)" to have low p-value -> big number and high p-value -> low number. It shouldn't contain any header
    # weights_file = os.path.join(rwrd, "data/HOXA_tAML_padj_neglog_RWR.tsv")
    weights_file = os.path.join(rwrd, "data/tAML_P3_SNV_polyphen_15390_nodes.tsv")

    # output file
    # outfile = os.path.join(rwrd, "output/RW_HOXA_tAML.tsv")
    outfile = os.path.join(rwrd, "output/RW_tAML_P3_gt.tsv")

    # # optional
    # wd = os.getcwd()
    # print("Working directory is:", wd)
    # hd = pathlib.Path.home()
    # abs_rwrd = os.path.join(hd, rwrd)
    # print("Home directory is:", hd)
    # print("Changing directory to:", abs_rwrd)

    rwr(network_file, weights_file, outfile)
