<?php echo "<?php\n"; ?>

namespace <?php echo $namespace; ?>;

final class <?php echo $class_name; ?> implements <?php echo $interface_name; ?>

{
     public function create()
     {
         switch (true) {
             //  ... insert your code here.
             default:
                 throw new \RuntimeException(sprintf('The factory %s is not able to create an object with the given arguments', __CLASS__));
         }
     }
}

