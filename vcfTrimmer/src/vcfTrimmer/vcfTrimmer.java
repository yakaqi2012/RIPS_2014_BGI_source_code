package vcfTrimmer;

import java.io.*;
import java.util.*;

public class vcfTrimmer {

	// instance variables
	String headerLine;
	BufferedReader br_vcf;
	BufferedReader br_pos;
	PrintWriter pw;
	StringTokenizer st;
	String vcf_file;
	String pos_file;
	File vcf;
	File positions;
	String vcf_line;
	String target; // target position

	String chr;
	String pos;
	String id;
	String ref;
	String alt;
	String qual;
	String filter;
	String info;
	String format;
	String hc;

	// constructor
	public vcfTrimmer(String vcf_file, String pos_file)
			throws FileNotFoundException, IOException {
		// load vcf file
		vcf = new File(vcf_file);
		br_vcf = new BufferedReader(new FileReader(vcf));

		// load position file
		positions = new File(pos_file);
		br_pos = new BufferedReader(new FileReader(positions));

		// create PrintWriter
		String outputFile = vcf_file+".out.vcf"; 
		pw = new PrintWriter(outputFile, "UTF-8");
		//pw = new PrintWriter("the-file-name.txt", "UTF-8");

		// get rid of header
		headerLine = br_vcf.readLine();
		while (!headerLine.startsWith("chr1")) {
			headerLine = br_vcf.readLine();
		}
		
		// two while loops: (outside) target positions, (inside) lines of vcf
		// get a position
		while ((target = br_pos.readLine()) != null) {
			// process line by line until we find the position
			while ((vcf_line = br_vcf.readLine()) != null) {
				// tokenize line by tab
				st = new StringTokenizer(vcf_line, "\t");
				
				// get chromosome and position
				chr = st.nextToken();
				pos = st.nextToken();
				//System.out.println(pos);
				
				// check if position is greater than current target
				// (in this case the target is not present in the file)
				if (Integer.parseInt(pos) > Integer.parseInt(target)) {
					// get next target until is greater than or equal to
					// position
					while (Integer.parseInt(pos) > Integer.parseInt(target)) {
						target = br_pos.readLine();
					}
				}
				
				// check if position matches current target
				if (pos.equals(target)) {
					// get the rest of the tokens
					id = st.nextToken();
					ref = st.nextToken();
					alt = st.nextToken();
					qual = st.nextToken();
					filter = st.nextToken();
					info = st.nextToken();
					format = st.nextToken();
					hc = st.nextToken();
//d
					// put them into a line
					String found_line = chr + "\t" + pos + "\t" + id + "\t"
							+ ref + "\t" + alt + "\t" + qual + "\t" + filter
							+ "\t" + info + "\t" + format + "\t" + hc + "\t";

					// write them to the file
					pw.println(found_line);

					// break out of while loop
					break;
				}
			}
		}

		pw.close();
	}

	// methods
	public static void main(String[] args) throws FileNotFoundException,
			IOException {
		// create instance of vcfTrimmer
		
		for(int i=13;i<=20;i++)
		{
			String vcf="tumor.samtools."+i+".vcf";
			vcfTrimmer vt = new vcfTrimmer(vcf, "threshold_position.0.95.8.txt");
			
		}

		//	String vcf="tumor.samtools."+12+".vcf";
		//	vcfTrimmer vt12 = new vcfTrimmer(vcf, "threshold_position.0.95.8.txt");
	}
}
