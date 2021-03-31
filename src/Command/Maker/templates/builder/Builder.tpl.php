<?php echo "<?php\n"; ?>

namespace <?php echo $namespace; ?>;

final class <?php echo $class_name; ?> implements <?php echo $interface_name; ?>

{
     private $built = null;
     private bool $locked = false;

     public function build(): self
     {
         if ($this->locked) {
              throw new \LogicException(sprintf('The method %s cannot be called while the built increment is locked in class %s', __FUNCTION__, __CLASS__));
         }

         // ... insert your code here.

         $this->locked = true;

         return $this;
     }

     public function get()
     {
         if (null === $this->built) {
             throw new \LogicException(sprintf('The method %s cannot be called before the method %s in class %s', __FUNCTION__, 'build', __CLASS__));
         }

         //  ... insert your code here.

         return $this->built;
     }

     public function reset(): self
     {
         $this->built = null;
         $this->locked = false;

         return $this;
     }
}

