import { Flex, ThemeIcon, Title } from "@mantine/core"
import React from "react"
import { IconType } from "react-icons";


type FlaggedTitleProps = {
  titleText: string,
  leftIcon: IconType,
};

export const FlaggedTitle = ({ titleText, leftIcon: LeftIcon }: FlaggedTitleProps) => {
    return (
        <Flex justify={"flex-start"} align={"center"} my={"xs"}>
            {LeftIcon && (
            <ThemeIcon radius="md" color="red" mr={"xs"}>
                <LeftIcon size={20} color={'var(--mantine-color-white)'}  />
            </ThemeIcon>
            )}

            <Title order={1} fw={900} tt={"uppercase"}>{titleText}</Title>
        </Flex>
    )
}