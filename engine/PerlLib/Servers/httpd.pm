=head1 NAME

 Servers::httpd - i-MSCP httpd server implementation

=cut

# i-MSCP - internet Multi Server Control Panel
# Copyright (C) 2010-2017 by Laurent Declercq <l.declercq@nuxwin.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

package Servers::httpd;

use strict;
use warnings;
use iMSCP::Debug qw/ fatal /;

# httpd server instance
my $instance;

=head1 DESCRIPTION

 i-MSCP httpd server implementation.

=head1 PUBLIC METHODS

=over 4

=item factory( )

 Create and return httpd server instance

 Return httpd server instance

=cut

sub factory
{
    return $instance if $instance;

    my $package = $main::imscpConfig{'HTTPD_PACKAGE'} || 'Servers::noserver';
    eval "require $package";
    fatal( $@ ) if $@;
    $instance = $package->getInstance( );
}

=item can( $method )

 Checks if the httpd server package provides the given method

 Param string $method Method name
 Return subref|undef

=cut

sub can
{
    my (undef, $method) = @_;

    my $package = $main::imscpConfig{'HTTPD_PACKAGE'} || 'Servers::noserver';
    eval "require $package";
    fatal( $@ ) if $@;
    $package->can( $method );
}

=item getPriority( )

 Get server priority

 Return int Server priority

=cut

sub getPriority
{
    70;
}

END
    {
        return if $? || !$instance || ($main::execmode && $main::execmode eq 'setup');

        if ($instance->{'start'}) {
            $? = $instance->start( );
        } elsif ($instance->{'restart'}) {
            $? = $instance->restart( );
        }
    }

=back

=head1 AUTHOR

 Laurent Declercq <l.declercq@nuxwin.com>

=cut

1;
__END__
