from ast import Raise
import pandas as pd
import os
from argparse import ArgumentParser

def createArgParser():
    # Create argument parser
    description = "Prepare a gene expression file for cibersortx"
    argparser = ArgumentParser(description = description)
    argparser.add_argument('expression', type=str, 
                           help='Input expression file in tsv')
    argparser.add_argument('gene_col', type=str, 
                           help='column name for gene symbol')
    argparser.add_argument('expr_col', type=str, 
                           help='column name for expression level')
    argparser.add_argument('output', type=str, 
                           help='output file name')
    
    return argparser

def read_expr_file(filename):
    try:
        expr_data = pd.read_csv(filename, sep='\t')
    except FileNotFoundError:
        raise Exception("Expression file {} not found".format(filename))
    else:
        return expr_data

def prep(gene_expr_df, gene_col, expr_col, out_file):
    if gene_col not in gene_expr_df.columns or expr_col not in gene_expr_df:
        raise Exception("Gene or expression column name not found in expression file")
    
    gene_expr_df[[gene_col, expr_col]].copy().rename(columns={expr_col:"sample_{}".format(expr_col)}).to_csv(out_file, sep='\t', index=False)


if __name__ == '__main__':
    argparser = createArgParser()
    args = argparser.parse_args()

    expr_data = read_expr_file(args.expression)
    
    prep(expr_data, args.gene_col, args.expr_col, args.output)
    
