package annotationParser;

/*
 SNP Annotation Parser:
 This class is responsible for extracting all of the relevant 
 from the SNP annotation produced by snp_nexus.
 For example, how many of the SNPs we identified are associated
 with breast cancer? How many have an ID that matches a known
 driver of breast cancer?
 */
import java.io.*;
import java.util.*;

public class AnnotationParser {

	// instance variables
	BufferedReader br;
	StringTokenizer st;

	static final int DBSNP_COLUMN = 9;
	static final int GENE_COLUMN = 4;

	// constructor
	public AnnotationParser() {
		// do nothing
	}

	// methods
	public static void main(String[] args) throws FileNotFoundException,
			IOException {
		// create an instance of class
		AnnotationParser at = new AnnotationParser();

		// calculate database match percentage
		at.classificationRate("snplist_rest.txt");

		// see if we can find any known driver genes
		at.driverGenes("breast_cancer_genes.txt", "refseq_6647.txt");
		at.driverGenes("breast_cancer_genes.txt", "ensembl_6647.txt");
		at.driverGenes("breast_cancer_genes.txt", "ucsc_6647.txt");

		// browse through disease and phenotype db for keywords
		at.cancerKeywords("breast", "gad_6647.txt");
	}

	/*
	 * @parameter: takes a cancer keyword, such as "breast" or "lung"
	 * 
	 * @output: returns the SNPs IDs that have an association with that keyword.
	 */
	public void cancerKeywords(String keyword, String phenotype_table)
			throws FileNotFoundException, IOException {

		// load table
		String phenotype_database = phenotype_table.substring(0,
				phenotype_table.indexOf("_"));
		File phenotypes = new File(phenotype_table);
		BufferedReader br2 = new BufferedReader(new FileReader(phenotypes));

		// check the PHENOTYPE_COLUMN of each line and see if it matches
		// one of the genes in our list
		// tokenize snp line by tab
		String snp_line;
		int total = 0;
		int cancer_total = 0;
		String association;
		String phenotype;
		String disease;
		while ((snp_line = br2.readLine()) != null) {
			st = new StringTokenizer(snp_line, "\t");

			// take precautions against empty lines!
			if (st.hasMoreTokens()) {
				// throw out tokens before phenotype column
				/*
				 * for (int i = 0; i < 3; i++) { st.nextToken(); }
				 */
				st.nextToken(); // always present
				st.nextToken(); // always present

				association = st.nextToken(); // sometimes present
				if (association.toLowerCase().equals("y")
						|| association.toLowerCase().equals("n")) {
					// phenotype is next token
					phenotype = st.nextToken();
				} else {
					// that token was phenotype
					phenotype = association;
				}

				// check if this phenotype contains our keyword
				if (phenotype.contains(keyword)) {
					total++;
				}

				// get disease token (if it exists)
				if (st.hasMoreTokens()) {
					disease = st.nextToken().toLowerCase();

					// check if the disease class is cancer
					if (disease.contains("cancer")) {
						cancer_total++;
					}
				}
			}

		}

		if (total == 0) {
			System.out.println("Sorry, no matches. :(");
			System.out.println();
		} else {
			System.out.println("(" + phenotype_database + ") Total number of "
					+ keyword + " cancer SNPs: " + total + ".");
			System.out.println("(" + phenotype_database
					+ ") Total number of SNPs associated with cancer: "
					+ cancer_total + ".");
			System.out.println();
		}
	}

	/*
	 * DriverGenes checks if any of our SNP ID's match known breast cancer
	 * drivers. These known drivers are taken from SNPedia's breast cancer page.
	 * 
	 * @parameter: -
	 * 
	 * @output:
	 */
	public void driverGenes(String driver_genes, String gene_table)
			throws FileNotFoundException, IOException {

		// load driver genes into a vector
		File genes = new File(driver_genes);
		br = new BufferedReader(new FileReader(genes));

		String next_gene;
		Vector<String> oncogenes = new Vector<String>();
		while ((next_gene = br.readLine()) != null) {
			oncogenes.add(next_gene.toLowerCase());
		}

		// load table
		String gene_database = gene_table.substring(0, gene_table.indexOf("_"));
		File gene_consequences = new File(gene_table);
		BufferedReader br2 = new BufferedReader(new FileReader(
				gene_consequences));

		// check the GENE_COLUMN of each line and see if it matches
		// one of the genes in our list
		// tokenize snp line by tab
		String snp_line;
		Vector<String> seen = new Vector<String>();
		//Vector<String> matches = new Vector<String>();
		HashMap<String,Integer> matches = new HashMap<String,Integer>();
		String gene;
		while ((snp_line = br2.readLine()) != null) {
			st = new StringTokenizer(snp_line, "\t");

			// take precautions against empty lines!
			if (st.hasMoreTokens()) {
				// throw out tokens before dbSNP column
				for (int i = 0; i < 3; i++) {
					st.nextToken();
				}

				// get gene token
				gene = st.nextToken();

				// check if this gene is in our list of genes
				// already seen
				if (seen.contains(gene)) {
					// get next line
					if (matches.containsKey(gene.toUpperCase())) {
						int current = matches.get(gene.toUpperCase());
						matches.put(gene.toUpperCase(),current+1);
					}
				} else {
					// add to list of seen genes
					seen.add(gene);

					// check if gene is in our list of oncogenes
					if (oncogenes.contains(gene.toLowerCase())) {
						matches.put(gene.toUpperCase(), 1);
						//System.out.println("(" + gene_database
								//+ ") We have a match! It's " + gene + ".");
					}
				}
			}

		}

		if (matches.isEmpty())
			System.out.println("Sorry, no matches. :(");
		System.out.println();
		
		for (Map.Entry<String, Integer> entry : matches.entrySet()) {
			  String key = entry.getKey();
			  int value = entry.getValue();
			  System.out.println(key + " " + value);
		}
	}

	/*
	 * @parameter:
	 * 
	 * @output: outputs the ratio of true somatic mutations to total number of
	 * somatic mutations
	 */
	public void classificationRate(String coordinate_file)
			throws FileNotFoundException, IOException {
		// method: go through dbSP ID column (the 9th column in
		// Genomic Coordinates and External links table)
		int total = 0;
		int actual = 0;

		// load table
		File genomic_coordinates = new File(coordinate_file);
		br = new BufferedReader(new FileReader(genomic_coordinates));

		String snp_line;
		while ((snp_line = br.readLine()) != null) {
			// tokenize snp line by tab
			st = new StringTokenizer(snp_line, "\t");

			/*
			 * while (st.hasMoreTokens()) { System.out.println(st.nextToken());
			 * }
			 */

			// throw out tokens before ref column
			for (int i = 0; i < 3; i++) {
				st.nextToken();
			}

			// get ref and alt alleles
			String ref = st.nextToken();
			String alt = st.nextToken();

			// check if ref and alt are different
			if (!alt.equals("X")) {

				// increment total
				total++;

				// get to the dbSNP column
				st.nextToken(); // contig
				st.nextToken(); // contig position
				st.nextToken(); // band
				// check if tokenizer hasNext
				if (st.hasMoreTokens()) {
					// if so, increment true because we have a dbSNP ID
					// for that SNP
					actual++;
				}
			}
		}

		double rate = ((double) actual) / total;
		System.out.println("The database match percentage is: " + rate + ".");
		System.out.println("The total number of somatic mutations we found is: " + total + ".");
		System.out.println(
				
				);
	}
}
