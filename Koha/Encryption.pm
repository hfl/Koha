package Koha::Encryption;

# Copyright 2022 Koha Development Team
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;

use base qw( Crypt::CBC );

use Koha::Exceptions;

=head1 NAME

Koha::Encryption - Koha class to encrypt or decrypt strings

=head1 SYNOPSIS

  use Koha::Encryption;
  my $secret    = Koha::AuthUtils::generate_salt( 'weak', 16 );
  my $crypt     = Koha::Encryption->new;
  my $encrypted = $crypt->encrypt_hex($secret);
  my $decrypted = $crypt->decrypt_hex($encrypted);

  return 1 if $decrypted eq $secret;

It's based on Crypt::CBC

=cut

=head2 METHODS

=head3 new

    my $cipher = Koha::Encryption->new;

    Constructor. Uses encryption_key from koha-conf.xml.

=cut

sub new {
    my ( $class ) = @_;
    my $key = C4::Context->config('encryption_key');
    if( !$key ) {
        Koha::Exceptions::MissingParameter->throw('No encryption_key in koha-conf.xml');
    }
    return $class->SUPER::new(
        -key    => $key,
        -cipher => 'Cipher::AES'
    );
}

1;
