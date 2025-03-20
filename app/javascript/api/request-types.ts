export type DeserializerOptions = "base" | "json-api" | (<T>(a: T) => T);
export type SerializerOptions = <T>(a: T) => T;

export type RequestOptions = {
  data?: object;
  deserializer?: DeserializerOptions;
  headers?: object;
  queryParams?: object;
  method?: "get" | "post" | "put" | "delete";
  serializer?: SerializerOptions;
  params?: object;
  getFullResponse?: boolean;
};