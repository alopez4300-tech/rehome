import * as React from "react";
import { cn } from "../../lib/utils";

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {}

export const Card = React.forwardRef<HTMLDivElement, CardProps>(
  ({ className, ...props }, ref) => (
    <div
      className={cn(
        "rounded-xl border bg-white p-6 shadow-sm",
        className
      )}
      ref={ref}
      {...props}
    />
  )
);
Card.displayName = "Card";
