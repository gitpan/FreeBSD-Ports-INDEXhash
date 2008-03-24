package FreeBSD::Ports::INDEXhash;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK   = qw(INDEXhash);
@ISA         = qw(Exporter);
@EXPORT      = ();

=head1 NAME

FreeBSD::Ports::INDEXhash - Generates a hash out of the FreeBSD Ports index file.

=head1 VERSION

Version 1.0.2

=cut

our $VERSION = '1.0.2';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

	use FreeBSD::Ports::INDEXhash qw/INDEXhash/;

	my %hash=INDEXhash();

	my @keys=keys(%hash);

	my $keysInt=0;

	while(defined($keys[$keysInt])){
	    print "Name: ".$keys[$keysInt]."\n".
	            "Info: ".$hash{$keys[$keysInt]}{info}."\n".
	            "Prefix: ".$hash{$keys[$keysInt]}{prefix}."\n".
	            "Maintainer: ".$hash{$keys[$keysInt]}{maintainer}."\n".
	            "WWW: ".$hash{$keys[$keysInt]}{www}."\n".
	            "Categories: ".join(" ", @{$hash{$keys[$keysInt]}{categories}})."\n".
	            "E-deps: ".join(" ", @{$hash{$keys[$keysInt]}{Edeps}})."\n".
	            "B-deps: ".join(" ", @{$hash{$keys[$keysInt]}{Bdeps}})."\n".
	            "P-deps: ".join(" ", @{$hash{$keys[$keysInt]}{Pdeps}})."\n".
	            "R-deps: ".join(" ", @{$hash{$keys[$keysInt]}{Rdeps}})."\n".
	            "F-deps: ".join(" ", @{$hash{$keys[$keysInt]}{Fdeps}})."\n".
	            "\n";

    	$keysInt++;
	};



=head1 EXPORT

INDEXhash

=head1 FUNCTIONS

=head2 INDEXhash

This parses the FreeBSD ports index file and a hash of it. Upon error it returns undef.

If a path to it is not passed to this function, it chooses the file automatically. The
PORTSDIR enviromental varaiable is respected if using automatically.

=cut

sub INDEXhash {
	my $index=$_[0];
	
	if(!defined($index)){
		if(!defined($ENV{PORTSDIR})){
			$index="/usr/ports/INDEX-";

		}else{
			$index=$ENV{PORTSDIR}."/INDEX-";
		};

		my $fbsdversion=`uname -r`;
		chomp($fbsdversion);
		$fbsdversion =~ s/\..+// ;
		$index=$index.$fbsdversion;
	};

	#error out if the it is not a file
	if(! -f $index){
		return undef;
	};
	
	#read the index file
	if(!open(INDEXFILE, $index)){
		return undef;
	};
	my @rawindex=<INDEXFILE>;
	close(INDEXFILE);
	
	my %hash=();
	
	my $rawindexInt=0;
	while(defined($rawindex[$rawindexInt])){
		my @linesplit=split(/\|/, $rawindex[$rawindexInt]);

		$hash{$linesplit[0]}={path=>$linesplit[1],
								prefix=>$linesplit[2],
								info=>$linesplit[3],
								maintainer=>$linesplit[5],
								www=>$linesplit[9],
								Bdeps=>[],
								Rdeps=>[],
								Edeps=>[],
								Pdeps=>[],
								Fdeps=>[],
								categories=>[]
							};

		my $depsInt=0;

		my @Fdeps=split(/ /, $linesplit[12]);		
		while(defined($Fdeps[$depsInt])){
			push(@{$hash{$linesplit[0]}{Fdeps}}, $Fdeps[$depsInt]);
			
			$depsInt++;
		};


		$depsInt=0;
		my @Pdeps=split(/ /, $linesplit[11]);
		while(defined($Pdeps[$depsInt])){
			push(@{$hash{$linesplit[0]}{Pdeps}}, $Pdeps[$depsInt]);

			$depsInt++;
		};

		$depsInt=0;
		my @Edeps=split(/ /, $linesplit[10]);
		while(defined($Edeps[$depsInt])){
			push(@{$hash{$linesplit[0]}{Edeps}}, $Pdeps[$depsInt]);

			$depsInt++;
		};

		my @Rdeps=split(/ /, $linesplit[8]);
		while(defined($Edeps[$depsInt])){
			push(@{$hash{$linesplit[0]}{Rdeps}}, $Rdeps[$depsInt]);

			$depsInt++;
		};

		$depsInt=0;
		my @Bdeps=split(/ /, $linesplit[7]);
		while(defined($Bdeps[$depsInt])){
			push(@{$hash{$linesplit[0]}{Bdeps}}, $Bdeps[$depsInt]);

			$depsInt++;
		};

		$depsInt=0;
		my @categories=split(/ /, $linesplit[6]);
		while(defined($categories[$depsInt])){
			push(@{$hash{$linesplit[0]}{categories}}, $categories[$depsInt]);

			$depsInt++;
		};

		$rawindexInt++;
	};
	
	return %hash;
};

=head1 HASH FORMAT

The keys of the hash are names of the ports. Each entry is
then another hash. See the list of keys below for the description
of each one.

=head2 info

This is a short description of the port.

=head2 prefix

This is the install prefix the port will try to use.

=head2 maintainer

This is the email address for the port's maintainer.

=head2 www

This is the web site of a port inquestion.

=head2 Edeps

This is the extract depends of a port. This is a array.

=head2 Bdeps

This is the build depends for the port. This is a array.

=head2 Pdeps

This is the package depends for a port. This is a array.

=head2 Rdeps

This is the run depends of a port. This is a array.

=head2 Fdeps

This is the fetch depends of a port. This is a array.

=head2 categories

This is all the categories a specific port falls under. This is a array.

=head1 AUTHOR

Zane C. Bowers, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-freebsd-ports-indexhash at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FreeBSD-Ports-INDEXhash>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FreeBSD::Ports::INDEXhash


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=FreeBSD-Ports-INDEXhash>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/FreeBSD-Ports-INDEXhash>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/FreeBSD-Ports-INDEXhash>

=item * Search CPAN

L<http://search.cpan.org/dist/FreeBSD-Ports-INDEXhash>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Zane C. Bowers, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of FreeBSD::Ports::INDEXhash
