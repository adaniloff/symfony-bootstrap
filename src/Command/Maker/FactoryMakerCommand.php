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

final class FactoryMakerCommand extends AbstractMaker implements MakerCommandInterface
{
    private const TPL_DIR = 'src/Command/Maker/templates/factory';

    public static function getCommandName(): string
    {
        return 'app:make:factory';
    }

    public function configureCommand(Command $command, InputConfiguration $inputConf)
    {
        $command
            ->setDescription('Creates a new factory class')
            ->addArgument('name', InputArgument::OPTIONAL, sprintf('Choose a name for your factory class (e.g. <fg=yellow>%sFactory</>)', Str::asClassName(Str::getRandomTerm())))
        ;
    }

    public function generate(InputInterface $input, ConsoleStyle $io, Generator $generator)
    {
        $name = trim($input->getArgument('name'));

        $interface = $name;
        if ($pos = strrpos($interface, 'Factory')) {
            $interface = substr($interface, 0, -strlen('Factory'));
        }
        $interface .= 'FactoryInterface';

        $className = $generator->createClassNameDetails($name, 'Factory\\', 'Factory');
        $interfaceName = $generator->createClassNameDetails($interface, 'Factory\\', 'FactoryInterface');
        $generator->generateClass(
            $className->getFullName(),
            self::TPL_DIR.'/Factory.tpl.php',
            [
                'interface_name' => $interfaceName->getRelativeName(),
            ]
        );
        $generator->generateClass(
            $interfaceName->getFullName(),
            self::TPL_DIR.'/FactoryInterface.tpl.php',
            [
                'interface_name' => $interfaceName->getRelativeName(),
            ]
        );

        $generator->writeChanges();

        $this->writeSuccessMessage($io);
        $io->text([
            'Next: open your new factory class and customize it!',
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
