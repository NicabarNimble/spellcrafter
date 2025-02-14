import { createContext, ReactNode, useContext, useMemo } from "react";
import { SetupResult } from "./dojo/setup";
import { Account, RpcProvider } from "starknet";
import { useBurner } from "@dojoengine/create-burner";

type DojoContext = {
    setup: SetupResult;
    account: {
        create: () => void;
        list: () => any[];
        get: (id: string) => any;
        select: (id: string) => void;
        account: Account;
        masterAccount: Account;
        isDeploying: boolean;
        clear: () => void;
    };
}

const DojoContext = createContext<DojoContext | null>(null);

type Props = {
    children: ReactNode;
    value: SetupResult;
};

export const DojoProvider = ({ children, value }: Props) => {

    const { VITE_PUBLIC_MASTER_ADDRESS, VITE_PUBLIC_MASTER_PRIVATE_KEY, VITE_PUBLIC_ACCOUNT_CLASS_HASH, VITE_PUBLIC_NODE_URL } = import.meta.env;
    const currentValue = useContext(DojoContext);
    if (currentValue) throw new Error("DojoProvider can only be used once");

    const provider = useMemo(
        () =>
            new RpcProvider({
                nodeUrl: VITE_PUBLIC_NODE_URL!,
            }),
        [],
    );

    const masterAddress = VITE_PUBLIC_MASTER_ADDRESS!;
    const privateKey = VITE_PUBLIC_MASTER_PRIVATE_KEY!;
    const masterAccount = useMemo(
        () => new Account(provider, masterAddress, privateKey),
        [provider, masterAddress, privateKey],
    );

    const { create, list, get, account, select, isDeploying, clear } = useBurner({
        masterAccount: masterAccount,
        accountClassHash: VITE_PUBLIC_ACCOUNT_CLASS_HASH!,
    });

    const selectedAccount = useMemo(() => {
        return account || masterAccount;
    }, [account])

    const contextValue: DojoContext = {
        setup: value,    // the provided setup
        account: {
            create,        // create a new account
            list,          // list all accounts
            get,           // get an account by id
            select,        // select an account by id
            account: selectedAccount,       // the selected account
            masterAccount, // the master account
            isDeploying,   // is the account being deployed
            clear
        }
    }

    return <DojoContext.Provider value={contextValue}>{children}</DojoContext.Provider>;
};

export const useDojo = () => {
    const value = useContext(DojoContext);
    if (!value) throw new Error("Must be used within a DojoProvider");
    return value;
};
