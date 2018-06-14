# from:  http://search.cpan.org/dist/BioPerl/Bio/Tools/Run/StandAloneBlast.pm


# Local-blast "factory object" creation and blast-parameter
 # initialization:
 @params = (-database => 'swissprot', -outfile => 'blast1.out');			#setting the parameters
 $factory = Bio::Tools::Run::StandAloneBlast->new(@params);				#$factoy is an object variable

 # Blast a sequence against a database:
 $str = Bio::SeqIO->new(-file=>'t/amino.fa', -format => 'Fasta');			# replace 't/amino.fa' with '$seq'
 $input = $str->next_seq();									
 $input2 = $str->next_seq();								# input2 is used for running multiple blast searches using a milti-fasta f
 $blast_report = $factory->blastall($input);						# change blastall to blastp --> output will be stored in 'blast1.out' (from line 3)

