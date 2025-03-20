/**
 * A serialized resource as returned by JSON API.
 *
 * Generic types:
 *  - A: Attributes
 *  - L: Links
 *  - R: Relationships
 *  - M: Meta
 *
 * Usage:
 *
 * ```
 *  type Expense = JsonApiResource<{ amount: number }>;
 *
 *  const expense: Expense = { id: "3", type: "expenses", attributes: { amount: 100 } };
 *  // => { id: "3", type: "expenses", attributes: { amount: 100 } }
 * ```
 */
export type JsonApiResource<A, L = undefined, R = undefined, M = undefined> = {
    id: string;
    type: string;
    attributes: A;
  } & (L extends undefined ? {} : { links: L }) &
    (R extends undefined ? {} : { relationships: R }) &
    (M extends undefined ? {} : { meta: M });
  
  /**
   * A serialized document as returned by JSON API.
   *
   * Generic types:
   *  - T: JsonApiResource
   *  - M: Meta
   *  - I: Included
   *
   * Usage:
   *
   * ```
   *  type Expense = JsonApiResource<{ amount: number }>;
   *  type Meta = { total: number };
   *
   *  const expense: Expense = { id: "3", type: "expenses", attributes: { amount: 100 } };
   *  const resource: JsonApiDocument<Expense, Meta> = { data: expense, meta: { total: 1 } };
   *  // => { data: { id: "3", type: "expenses", attributes: { amount: 100 } }, meta: { total: 1 } }
   * ```
   */
  export type JsonApiDocument<
    T extends JsonApiResource<unknown> | JsonApiResource<unknown>[],
    M = undefined,
    I = undefined,
  > = {
    data: T;
  } & (M extends undefined ? {} : { meta: M }) &
    (I extends undefined ? {} : { included: I });
  
  export type Relationship = {
    id: string;
    type: string;
  };
  