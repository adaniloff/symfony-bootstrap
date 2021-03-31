<?php

declare(strict_types=1);

namespace App\Command\Maker;

use Symfony\Bundle\MakerBundle\ConsoleStyle;
use Symfony\Bundle\MakerBundle\DependencyBuilder;
use Symfony\Bundle\MakerBundle\Generator;
use Symfony\Bundle\MakerBundle\InputConfiguration;
use Symfony\Bundle\MakerBundle\Maker\AbstractMaker;
use Symfony\Bundle\MakerBundle\Str;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;

final class BuilderMakerCommand extends AbstractMaker implements MakerCommandInterface
{
    private const TPL_DIR = 'src/Command/Maker/templates/builder';

    public static function getCommandName(): string
    {
        return 'app:make:builder';
    }

    public function configureCommand(Command $command, InputConfiguration $inputConf)
    {
        $command
            ->setDescription('Creates a new builder class')
            ->addArgument('name', InputArgument::OPTIONAL, sprintf('Choose a name for your builder class (e.g. <fg=yellow>%sBuilder</>)', Str::asClassName(Str::getRandomTerm())))
        ;
    }

    public function generate(InputInterface $input, ConsoleStyle $io, Generator $generator)
    {
        $name = trim($input->getArgument('name'));

        $interface = $name;
        if ($pos = strrpos($interface, 'Builder')) {
            $interface = substr($interface, 0, -strlen('Builder'));
        }
        $interface .= 'BuilderInterface';

        $className = $generator->createClassNameDetails($name, 'Builder\\', 'Builder');
        $interfaceName = $generator->createClassNameDetails($interface, 'Builder\\', 'BuilderInterface');
        $generator->generateClass(
            $className->getFullName(),
            self::TPL_DIR.'/Builder.tpl.php',
            [
                'interface_name' => $interfaceName->getRelativeName(),
            ]
        );
        $generator->generateClass(
            $interfaceName->getFullName(),
            self::TPL_DIR.'/BuilderInterface.tpl.php',
            [
                'interface_name' => $interfaceName->getRelativeName(),
            ]
        );

        $generator->writeChanges();

        $this->writeSuccessMessage($io);
        $io->text([
            'Next: open your new builder class and customize it!',
        ]);
    }

    public function configureDependencies(DependencyBuilder $dependencies)
    {
        $dependencies->addClassDependency(
            Command::class,
            'console'
        );
    }
}
