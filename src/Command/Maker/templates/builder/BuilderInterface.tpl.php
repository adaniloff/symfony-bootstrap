<?php echo "<?php\n"; ?>

namespace <?php echo $namespace; ?>;

interface <?php echo $interface_name; ?> extends \App\Builder\BuilderInterface
{
     public function get(); // todo: override typehint or remove signature and delete this comment
}

