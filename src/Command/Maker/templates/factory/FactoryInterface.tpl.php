<?php echo "<?php\n"; ?>

namespace <?php echo $namespace; ?>;

interface <?php echo $interface_name; ?> extends \Ayruu\SDK\Api\Bridge\Symfony\Factory\FactoryInterface
{
     public function create(); // todo: override typehint or remove signature and delete this comment
}

