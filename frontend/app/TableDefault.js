"use client"; // This is a client component 👈🏽
import React, { useEffect, useState } from "react";
import {
  ChakraProvider,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  chakra,
  Button,
  Spinner,
} from "@chakra-ui/react";

export default function TableDefault({ data }) {
  console.log(data);
  return (
    <ChakraProvider>
      <Table id="transactions">
        <Thead>
          <Tr>
            <Th>Date</Th>
            <Th>Transaction</Th>
            <Th>Amount Left</Th>
          </Tr>
        </Thead>
        <Tbody>
          {data.slice(0).map((row, key) => (
            <Tr key={row.id}>
              <Td id={`date-${key}`}>
                {new Date(row.created_at).toLocaleDateString()}
              </Td>
              <Td id={`amount-${key}`}>{`${
                row.transaction_type === "NCD" ? "+" : "-"
              }${row.amount}`}</Td>
              <Td id={`balance-${key}`}>{row.user_balance_left + "0"}</Td>
            </Tr>
          ))}
        </Tbody>
      </Table>
    </ChakraProvider>
  );
}
