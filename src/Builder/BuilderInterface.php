<?php

declare(strict_types=1);

namespace App\Builder;

interface BuilderInterface
{
    public function build(): self;

    public function get();

    public function reset(): self;
}
