use Test::More tests => 1;

use qbit;
use File::Temp qw(tempfile);

my $data = <<EOF;
    Test text
    Тестовый текст для проверки UTF
EOF

my (undef, $filename) = tempfile('pragmaqbit-file-test_XXXX', SUFFIX => '.txt', TMPDIR => 1, OPEN => 0);
END {
    unlink($filename) if $filename;
}

writefile($filename => $data);

is(
    readfile($filename),
    $data,
    "Write/Read file"
);
