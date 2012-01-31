package HTML::FormHandler::Test;
# ABSTRACT: provides is_html method used in tests
use strict;
use warnings;
use HTML::TreeBuilder;
use Test::Builder::Module;
use base 'Test::Builder::Module';
our @EXPORT = ('is_html');

=head1 SYNOPSIS

Simple 'is_html' method for testing form rendering against
an expected value without having to fuss with exactly matching
newlines and spaces. Uses L<HTML::TreeBuilder>, which uses
L<HTML::Parser>.

See numerous examples in the 't/render' directory.

   use Test::More;
   use HTML::FormHandler::Test;
   use_ok('MyApp::Form::Basic');
   my $form = MyApp::Form::Basic->new;
   $form->process;
   my $expected = '<form html>';
   is_html( $form->render, $expected, 'form renders ok' );

=cut

sub is_html {
    my ( $got, $expected, $message ) = @_;
    my $t1 = HTML::TreeBuilder->new;
    my $t2 = HTML::TreeBuilder->new;

    # TreeBuilder collapses a newline or a newline followed by space into
    # a single space, which won't match against no space, so remove.
    $got =~ s/\n\s*//sg;
    $expected =~ s/\n\s*//sg;
    $t1->parse($got);
    $t1->eof;
    $t2->parse($expected);
    $t2->eof;
    my $out1 = $t1->as_XML;
    my $out2 = $t2->as_XML;
    $t1->delete;
    $t2->delete;
    my $tb = HTML::FormHandler::Test->builder;
    return $tb->is_eq($out1, $out2, $message);
}

1;