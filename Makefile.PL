use 5.008005;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME           => 'Algorithm::ConsistentHash::MultiProbeXS',
    VERSION_FROM   => 'lib/Algorithm/ConsistentHash/MultiProbeXS.pm',
    PREREQ_PM      => {
      'Test::More' => 0,
      'ExtUtils::ParseXS' => '3',
    },
    ABSTRACT_FROM  => 'lib/Algorithm/ConsistentHash/MultiProbeXS.pm',
    AUTHOR         => 'Steffen Mueller <smueller@cpan.org>',
    LIBS           => [''],         # e.g., '-lm'
    DEFINE         => '-std=c99',           # e.g., '-DHAVE_SOMETHING'
    INC            => '-I.',        # e.g., '-I. -I/usr/include/other'
    OBJECT         => '$(O_FILES)', # link all the C files too
);

