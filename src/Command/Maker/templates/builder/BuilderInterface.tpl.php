<?php echo "<?php\n"; ?>

namespace <?php echo $namespace; ?>;

interface <?php echo $interface_name; ?> extends \Ayruu\SDK\Api\Bridge\Symfony\Builder\BuilderInterface
{
     public function get(); // todo: override typehint or remove signature and delete this comment
}

