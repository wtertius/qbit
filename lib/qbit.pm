#ABSTRACT: Pragma qbit

=head1 Name

qbit - Setup envirement to development modern perl applications and add some functions.

=head1 Description

Using this pragma is equivalent:

 use strict;
 use warnings FATAL => 'all';
 use utf8;
 use open qw(:std utf8);

 use Scalar::Util qw(set_prototype blessed dualvar isweak readonly refaddr reftype tainted weaken isvstring looks_like_number);
 use Data::Dumper qw(Dumper);
 use Clone        qw(clone);

 use pragmaqbit::Exceptions;
 use pragmaqbit::Log;
 use pragmaqbit::Array;
 use pragmaqbit::Hash;
 use pragmaqbit::GetText;
 use pragmaqbit::Packages;
 use pragmaqbit::StringUtils;
 use pragmaqbit::Date;
 use pragmaqbit::File;

=head1 Synopsis

 use qbit;

 sub myfunc {
     my ($a1, $a2) = @_;

     throw Exception::BadArguments gettext('First argument must be defined')
         unless defined($a1);

     return ....
 }

 try {
    my $data = myfunc(@ARGV);
    ldump($data);
 } catch Exception::BadArguments with {
     l shift->as_string();
 };

=head1 Internal packages

=over

=item B<L<pragmaqbit::Exceptions>> - realize base classes and functions to use exception in perl;

=item B<L<pragmaqbit::Log>> - there're some function to simple logging;

=item B<L<pragmaqbit::Array>> - there're some function to working with arrays;

=item B<L<pragmaqbit::Hash>> - there're some function to working with hashes;

=item B<L<pragmaqbit::GetText>> - there're some function to internationalization your's software;

=item B<L<pragmaqbit::Packages>> - there're some function to access package internals;

=item B<L<pragmaqbit::StringUtils>> - there're some function to working with strings;

=item B<L<pragmaqbit::Date>> - there're some function to working with dates;

=item B<L<pragmaqbit::File>> - there're some function to manage files.

=back

=cut

package qbit;

use strict;
use warnings FATAL => 'all';
use utf8;
use open();
use Scalar::Util ();
use Data::Dumper ();
use Clone        ();

use pragmaqbit::Exceptions  ();
use pragmaqbit::Log         ();
use pragmaqbit::Array       ();
use pragmaqbit::Hash        ();
use pragmaqbit::GetText     ();
use pragmaqbit::Packages    ();
use pragmaqbit::StringUtils ();
use pragmaqbit::Date        ();
use pragmaqbit::File        ();

sub import {
    $^H |= $utf8::hint_bits;
    $^H |= 0x00000002 | 0x00000200 | 0x00000400;

    ${^WARNING_BITS} |= $warnings::Bits{'all'};
    ${^WARNING_BITS} |= $warnings::DeadBits{'all'};

    my $pkg         = caller;
    my $pkg_sym_tbl = pragmaqbit::Packages::package_sym_table($pkg);

    {
        no strict 'refs';
        *{"${pkg}::TRUE"}  = sub () {1};
        *{"${pkg}::FALSE"} = sub () {''};
    }

    Scalar::Util->export_to_level(
        1, undef,
        @{
            pragmaqbit::Array::arrays_difference(
                [
                    qw(set_prototype blessed dualvar isweak readonly refaddr reftype tainted weaken isvstring looks_like_number)
                ],
                [keys(%$pkg_sym_tbl)]
            )
          }
    );    # Don't export functions, if they were imported before

    Data::Dumper->export_to_level(1, qw(Dumper));

    Clone->export_to_level(1, undef, qw(clone));

    pragmaqbit::Exceptions->export_to_level(1);
    pragmaqbit::Log->export_to_level(1);
    pragmaqbit::Array->export_to_level(1);
    pragmaqbit::Hash->export_to_level(1);
    pragmaqbit::Packages->export_to_level(1);
    pragmaqbit::GetText->export_to_level(1);
    pragmaqbit::StringUtils->export_to_level(1);
    pragmaqbit::Date->export_to_level(1);
    pragmaqbit::File->export_to_level(1);

    @_ = qw(open :std :utf8);
    goto &open::import;
}

1;
